import os
import inspect

from lettuce import *
from lettuce_webdriver.util import (assert_true,
                                    AssertContextManager)
from selenium.webdriver import ActionChains
from nose.tools import assert_equal

import sys
import time

current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)
sys.path.insert(0, parent_dir)
from prepare_loans import prepare_loans
from prepare_loans import prepare_loans_in_chunk
from prepare_loans import prepare_grouping_data
from prepare_loans import prepare_grouped_loans
from prepare_loans import prepare_lazy_loaded_grouped_loans
from prepare_loans import prepare_grand_total_row

import requests
import json
import basic_opr_module as bo

spanWidthPix = 1


def get_url(browser, url):
    browser.get(url)


def find_elements_by_class(browser, className):
    elements = browser.find_elements_by_class_name(className)
    return elements


def find_elements_by_css(browser, css):
    elements = browser.find_elements_by_css_selector(css)
    return elements


def check_fields_counts_by_css(browser, css, num):
    elements = browser.find_elements_by_css_selector(css)
    assert len(elements) == int(num)


def execute_js_script(browser, script):
    return browser.execute_script(script)


def wait_for_elem(browser, script, timeout=20):
    start = time.time()
    elems = []
    while time.time() - start < timeout:
        elems = browser.execute_script(str(script))
        if elems:
            return elems
        time.sleep(0.2)
    return elems


def drag_element_by_offset_class_name(browser, class_name, index, right_or_left, offset):
    elements = find_elements_by_class(browser, class_name)
    action_chains = ActionChains(browser)
    if str(right_or_left) == "left":
        action_chains.drag_and_drop_by_offset(elements[int(index) - 1], -int(offset), 0).perform()
    else:
        action_chains.drag_and_drop_by_offset(elements[int(index) - 1], int(offset), 0).perform()


# the index starts from 1
def get_column_header_name(browser, css, index):
    columns_header = find_elements_by_css(browser, css)
    return columns_header[int(index) - 1].text


def sort_column_by_css(browser, css, index):
    columns_header = find_elements_by_css(browser, css)
    columns_header[int(index) - 1].click()


def get_mb_request():
    text = requests.get("http://localhost:2525/imposters/8888").json()
    dump_text = json.dumps(text)
    to_json = json.loads(dump_text)['requests']

    return to_json


@step('I visit "(.*?)"$')
def visit(step, url):
    with AssertContextManager(step):
        world.browser.get(url)


@step('There are (\d+) loans$')
def fill_in_textfield_by_class(step, num):
    with AssertContextManager(step):
        prepare_loans(int(num) - 2)


@step('There are (\d+) loans in chunk size (\d+)$')
def there_are_loans_in_chunk(step, total_count, chunk_size):
    with AssertContextManager(step):
        prepare_loans_in_chunk(int(total_count), int(chunk_size))


@step('Presenting "(.*?)"')
def list_all_loans(step, url):
    with AssertContextManager(step):
        options = {
            "the list of loans": "http://localhost:4200/fully-loaded-loans",
            "groups": "http://localhost:4200/groups",
            "column sort": "http://localhost:4200/lazy-loaded-loans?totalCount=200",
            "column reorder": "http://localhost:4200/groups-reorder",
            "inner column sort": "http://localhost:4200/groups-sort",
            "lazy load page": "http://localhost:4200/lazy-loaded-loans?totalCount=200",
            "grouping column": "http://localhost:4200/grouping-column",
            "grouping column with fixed columns": "http://localhost:4200/grouping-column-and-fixed",
            "grouping column with pluggable indicator": "http://localhost:4200/custom-group-indicator",
            "grouping column with pluggable loading indicator": "http://localhost:4200/grouped-row-loading-indicator",
            "grouping column present partial loaded children": "http://localhost:4200/chunked-grouping-rows",
            "grand total row": "http://localhost:4200/grand-total-row",
            "grouping column error handling": "http://localhost:4200/grouped-rows-error-handling",
            "grouper sort": "http://localhost:4200/sort-by-grouper"
        }
        get_url(world.browser, options.get(url))


@step('The content "(.*?)" should display in page$')
def check_page_source(step, content):
    with AssertContextManager(step):
        assert_true(step, content.strip() in world.browser.page_source)


@step('(\d+) loans should be shown in a table, from the outset')
def check_all_loans_shown(step, num):
    with AssertContextManager(step):
        check_fields_counts_by_css(world.browser, ".ember-table-body-container .ember-table-table-row",
                                   num)


@step('The page load time should be longer than ten seconds')
def wait_page_load(step):
    with AssertContextManager(step):
        # TODO: the wait time will be implemented in future
        pass


@step('I want to drag element by class "(.*?)" and the (\d+) column to "(.*?)" with (-?\d+)$')
def drag_element_offset(step, class_name, index, right_or_left, offsetx):
    with AssertContextManager(step):
        original_width = bo.get_column_width_by_class_name(world.browser, index)
        drag_element_by_offset_class_name(world.browser, class_name, index, right_or_left, offsetx)
        changed_width = bo.get_column_width_by_class_name(world.browser, index)

        if str(right_or_left) == "left":
            assert_true(step, (int(changed_width) - int(original_width)) == (-int(offsetx) - int(1)))
        else:
            assert_true(step, (int(changed_width) - int(original_width)) == (int(offsetx) - int(1)))


@step('I want to sort column with index (\d+) by css "(.*?)"')
def sort_column(step, index, css):
    with AssertContextManager(step):
        sort_column_by_css(world.browser, css, index)


@step('Customer drags scroll bar by offset (\d+) with (\d+) times$')
def drag_scroll_bar_with_offset(step, offset, times):
    with AssertContextManager(step):
        bo.drag_scroll_by_css_with_times(world.browser, offset, times)


@step('Customer drags scroll bar by offset (\d+) with (\d+) times and wait loading section$')
def drag_scroll_bar_with_offset_after_loading(step, offset, times):
    with AssertContextManager(step):
        bo.drag_scroll_by_css_with_times_after_loading(world.browser, offset, times)


@step('Only first chunk was loaded in total (\d+) in first time')
def check_loaded_chunk(step, num):
    with AssertContextManager(step):
        get_url(world.browser, "http://localhost:4200/lazy-loaded-loans?totalCount=" + str(num))
        text = requests.get("http://localhost:2525/imposters/8888").json()
        dump_text = json.dumps(text)
        to_json = json.loads(dump_text)['requests']

        assert_true(step, len(to_json) == 1)
        assert_true(step, to_json[0]['query']['section'] == "1")


@step('There should be (\d+) sections loaded')
def get_loaded_section(step, num, timeout=3):
    start = time.time()
    while time.time() - start < timeout:
        if len(get_mb_request()) == int(num):
            return
        time.sleep(0.5)
    raise AssertionError


@step(
    'Scroll bar by offset (\d+) with (\d+) times to load next chunks in total (\d+) and drag scroll bar to top without rerender')
def check_next_chunk_loaded(step, offsety, times, num):
    get_url(world.browser, "http://localhost:4200/lazy-loaded-loans?totalCount=" + str(num))

    bo.drag_scroll_by_css_with_times(world.browser, offsety, times)
    assert len(get_mb_request()) == int(times) + 1

    bo.drag_scroll_to_top(world.browser, -int(offsety))
    assert len(get_mb_request()) == int(times) + 1


@step('The page should style for entire group, inner column, first column and last column')
def check_fields_class_by_css(step):
    with AssertContextManager(step):
        assert_true(step, "text-red" in bo.get_grouped_column_css(world.browser, "Group1"))
        assert_true(step, "text-blue" in bo.get_grouped_column_css(world.browser, "Activity"))
        assert_true(step, "bg-gray" in bo.get_grouped_column_css(world.browser, "Activity"))
        assert_true(step, "text-blue" in bo.get_grouped_column_css(world.browser, "status"))
        assert_true(step, "bg-lightgray" in bo.get_grouped_column_css(world.browser, "status"))


@step('Click to sort as "(.*?)" for column "(.*?)"$')
def click_to_sort_column(step, asc_or_desc, column_name="Id"):
    with AssertContextManager(step):
        bo.wait_loading_indicator_disappear(world.browser)
        bo.sort_column(world.browser, column_name)


@step('"(.*?)" click to sort as "(.*?)" for column "(.*?)"')
def command_ctrl_click_column(step, command_or_ctrl, asce_or_desc, col_name):
    with AssertContextManager(step):
        bo.wait_loading_indicator_disappear(world.browser)
        bo.command_ctrl_with_click(world.browser, col_name, command_or_ctrl)


@step('The "(.*?)" record should be "(.*?)"$')
def check_sort_column(step, record_index, record_content):
    with AssertContextManager(step):
        if record_index == "first":
            result = bo.get_record_content(world.browser, 0)
            assert_true(step, str(result) == record_content)
        elif record_index == "last":
            result = bo.get_record_content(world.browser, 1)
            assert_true(step, str(result) == record_content)
        else:
            result = bo.get_record_content(world.browser, 3)
            assert_true(step, str(result) == record_content)


@step('Drag scroll bar to "(.*?)"')
def drag_scroll_bar(step, top_or_bottom):
    with AssertContextManager(step):
        offsety = 60
        if top_or_bottom == "bottom":
            bo.drag_scroll_to_bottom(world.browser, offsety)
        else:
            bo.drag_scroll_to_top(world.browser, -int(offsety))


@step('Drag horizontal scroll bar with (\d+) pixel$')
def drag_horizontal_scroll_bar(step, offsetx):
    with AssertContextManager(step):
        bo.drag_horizontal_offset(world.browser, offsetx)


@step('The column header block should has "(.*?)" and same as body scroll left$')
def check_header_scroll_left(step, name):
    with AssertContextManager(step):
        start = time.time()
        flag = False
        while time.time() - start < 20:
            if int(bo.get_head_block_scroll_left(world.browser)) == int(bo.get_body_scroll_left(world.browser)):
                flag = flag or True
                break
            time.sleep(0.2)
        assert_true(step, flag)


@step('The user get the resize cursor in "(.*?)" column')
def get_column_cursor(step, column_name):
    with AssertContextManager(step):
        cursor_css = "body.ember-application"

        action_chains = ActionChains(world.browser)
        element = world.browser.execute_script(
            "return $('.ember-table-header-container .ember-table-content:contains(" + column_name + ")').parent().parent().children()[1]")
        action_chains.drag_and_drop_by_offset(element, 10, 0).release().perform()

        cursor = find_elements_by_css(world.browser, cursor_css)
        style = cursor[0].get_attribute("style")
        assert_true(step, ("auto" in style) or ("resize" in style) or ("pointer" in style))
        action_chains.release()
        world.browser.refresh()


@step('The user drags the "(.*?)" on column to "(.*?)" with (\d+) pixel')
def drag_column_with_pixel(step, column_name, left_or_right, offsetx):
    with AssertContextManager(step):
        if str(column_name) == "GroupingColumn":
            bo.resize_column_by_index(world.browser, 0, left_or_right, offsetx)
        else:
            bo.resize_column(world.browser, column_name, left_or_right, offsetx)


@step('Reorder an inner column "(.*?)" header to "(.*?)" with (\d+) pixel')
def reorder_column_with_pixel(step, column_name, left_or_right, offsetx):
    with AssertContextManager(step):
        if str(column_name) == "GroupingColumn":
            bo.reorder_column_by_index(world.browser, 0, left_or_right, offsetx)
        else:
            bo.reorder_column(world.browser, column_name, left_or_right, offsetx)


@step('The reorder indicator line should be (\d+) from left$')
def get_reorder_indicator(step, pixel):
    with AssertContextManager(step):
        style = world.browser.execute_script(
            "return $('.ember-table-column-sortable-indicator.active').attr(\"style\")")
        indicator = str(style).split("left:")[1].split("px")[0].strip()

        assert_true(step, int(indicator) == int(pixel))


@step('Drag and hold column "(.*?)" to "(.*?)" with (\d+) pixel$')
def drag_hold_column(step, column_name, left_or_right, offsetx):
    with AssertContextManager(step):
        chains = ActionChains(world.browser)
        wait_for_elem(world.browser, "return $('.ember-table-content-container')")
        element = world.browser.execute_script(
            "return $('.ember-table-content-container .ember-table-content:contains(" + column_name + ")')")
        if left_or_right == "left":
            chains.click_and_hold(element[0]).move_by_offset(-int(offsetx), 0).perform()
        else:
            chains.click_and_hold(element[0]).move_by_offset(int(offsetx), 0).perform()


@step('The "(.*?)" column width should be (\d+) pixel')
def check_column_width(step, column_name, pixel):
    with AssertContextManager(step):
        if str(column_name) == "GroupingColumn":
            assert_true(step, int(bo.get_col_width_by_index(world.browser, 0)) == int(pixel))
        else:
            assert_true(step, int(bo.get_col_width(world.browser, column_name)) == int(pixel))


@step('The "(.*?)" column header height should be (\d+) pixel$')
def check_column_header_height(step, column_name, pixel):
    with AssertContextManager(step):
        assert_true(step, int(bo.get_col_header_height(world.browser, column_name)) == int(pixel))


@step('The index (\d+) should be "(.*?)" column$')
def check_reorder_column(step, index, name, timeout=5):
    with AssertContextManager(step):
        if name == "GroupingColumn":
            assert_true(step, bo.get_col_name_by_index(world.browser, index) == "")
        else:
            assert_true(step, bo.get_col_name_by_index(world.browser, index) == name)


@step('The "(.*?)" column sort indicator should be "(.*?)"$')
def check_sort_indicator(step, column_name, sort):
    with AssertContextManager(step):
        class_content = world.browser.execute_script(
            "return $('.ember-table-header-container .ember-table-content:contains(" + column_name + ") .column-sort-indicator').attr(\'class\')")

        options = {"none": "",
                   "asc": "sort-indicator-icon sort-indicator-icon-up",
                   "desc": "sort-indicator-icon sort-indicator-icon-down", }
        if options.get(sort) == "none":
            assert_true(step, "sort-indicator-icon" not in class_content)
        else:
            assert_true(step, options.get(sort) in class_content)


@step('The "(.*?)" column sort order is "(.*?)"$')
def check_sort_column_queue(step, col_name, queue_num):
    with AssertContextManager(step):
        queue = world.browser.execute_script(
            "return $('.ember-table-header-container .ember-table-content:contains(" + col_name + ") .column-sort-indicator span').text().trim()")
        assert_true(step, str(queue) == str(queue_num)) if str(queue_num) != "blank" else assert_true(step,
                                                                                                      str(queue) == "")


@step('I have the following grouped loans in MounteBank:')
def prepare_grouped_loans_in_mb(step):
    with AssertContextManager(step):
        prepare_grouped_loans(step.hashes)


@step('I have the following partial loaded grouped data in MounteBank:')
def prepare_lazy_loaded_group_data_in_mb(step):
    with AssertContextManager(step):
        prepare_lazy_loaded_grouped_loans(step.hashes)


@step('I have one grand total row in MounteBank')
def prepare_grand_total_row_in_mb(step):
    with AssertContextManager(step):
        prepare_grand_total_row()


@step('I see grouped rows:$')
def verify_grouped_rows(step, timeout=5):
    for index in range(0, len(step.hashes)):
        start = time.time()
        while time.time() - start < timeout:
            indicator = world.browser.execute_script("return $('.row-loading-indicator.loading')")
            if len(indicator) == 0:
                break
            time.sleep(0.2)
        verify_grouped_row(index, step.hashes[index])


@step('I see rows:$')
def verify_grouped_rows(step):
    for index in range(0, len(step.hashes)):
        for field in step.hashes[index]:
            verify_cell_content(index, field, step.hashes[index][field])


def verify_grouped_row(index, row):
    indicator = row['indicator']
    if indicator == '-':
        assert_true(step, is_the_row_expanded(index))
    elif indicator == '+':
        assert_true(step, (not is_the_row_expanded(index)) and (not is_the_leaf_node(index)))
    elif indicator == '':
        assert_true(step, is_the_leaf_node(index))

    for field in row:
        if field != 'indicator':
            verify_cell_content(index, field, row[field])


def is_the_row_expanded(index):
    script = ".find('.ember-table-cell:eq(0) .grouping-column-indicator').hasClass('unfold')"
    return world.browser.execute_script(script_with_row('left', index) + script)


def is_the_leaf_node(index):
    script = ".find('.ember-table-cell:eq(0) .grouping-column-indicator:has(div)').length"
    length = world.browser.execute_script(script_with_row('left', index) + script)
    return int(length) == 0


def script_with_row(block, row_index):
    return "var rows = $('.ember-table-body-container .ember-table-%s-table-block .ember-table-table-row:visible').toArray(); \
        rows = rows.filter(function(row){ return $(row).offset().top > $('.antiscroll-inner').offset().top - 20}); \
        rows.sort(function(i, j){ return parseInt(i.style.top) - parseInt(j.style.top) }); \
        return $(rows[%s])" % (block, row_index)


def verify_cell_content(row_index, name, value):
    col_index, is_fixed = find_col_index(name)
    block_selector = 'left' if is_fixed else 'right'
    script = ".find('.ember-table-cell:eq(%s) span').text().trim()" % col_index
    col_value = world.browser.execute_script(script_with_row(block_selector, row_index) + script)
    assert_equal(str(col_value).strip(), str(value).strip())


def find_col_index(name):
    if name == 'groupName':
        return 0, True

    col_index = do_find_col_index(name, True)
    if col_index:
        return col_index, True
    else:
        return do_find_col_index(name, False), False


def do_find_col_index(name, in_fixed_block):
    block_selector = '.ember-table-right-table-block'
    if in_fixed_block:
        block_selector = '.ember-table-left-table-block'

    col_count = world.browser.execute_script(
        "return $('.ember-table-header-container " + block_selector + " .ember-table-header-cell').length")
    for i in range(0, col_count):
        headerName = world.browser.execute_script(
            " return $('.ember-table-header-container " + block_selector +
            " .ember-table-table-row > div .ember-table-header-cell:eq(" + str(
                i) + ") .ember-table-content-container > span').text().trim()")
        if name in headerName:
            return i


@step('There are (\d+) columns$')
def check_columns_numbers(step, num):
    with AssertContextManager(step):
        col_count = world.browser.execute_script(
            "return $('.ember-table-content-container .ember-table-content').length")
        assert_equal(int(col_count), int(num))


@step('Click "(.*?)" for row "(.*?)"$')
def expand_collapse_row(step, expand_collapse, row_name):
    with AssertContextManager(step):
        bo.expand_collapse_row(world.browser, row_name)


@step('Click "(.*?)" for the (\d+) row to check indicator$')
def expand_collapse_row(step, expand_collapse, index):
    with AssertContextManager(step):
        bo.stop_mb()
        bo.expand_collapse_row_by_index(world.browser, index)


@step('Click "(.*?)" for the (\d+) row$')
def expand_collapse_row_by_index(step, expand_collapse, index):
    with AssertContextManager(step):
        bo.expand_collapse_row_by_index(world.browser, index)


@step('Collapse all expanded rows')
def collapse_expanded_rows(step):
    with AssertContextManager(step):
        row = find_elements_by_css(world.browser, ".ember-table-toggle.ember-table-collapse")
        array = []
        for i in range(0, len(row)):
            row_name = world.driver.execute_script(
                "return $('.ember-table-toggle.ember-table-collapse:eq(" + str(i) + ")').siblings().text().trim()")
            array.append(row_name)
        for i in range(2, array.__len__())[::-1]:
            element = world.driver.execute_script(
                "return $('.ember-table-content:contains(" + str(array[i - 1]) + ")').siblings()")
            element[0].click()


@step('The row "(.*?)" indicator should be "(.*?)"$')
def check_row_indicator(step, row_name, indicator):
    with AssertContextManager(step):
        row = world.browser.execute_script(
            "return $('.ember-table-content:contains(" + str(row_name) + ")').siblings()")
        if indicator == "expand":
            assert_true(step, "unfold" not in row[1].get_attribute("class"))
        else:
            assert_true(step, "unfold" in row[1].get_attribute("class"))


@step('The (\d+) row indicator should be "(.*?)"$')
def check_row_indicator(step, index, indicator):
    with AssertContextManager(step):
        if indicator == 'collapse':
            assert_true(step, is_the_row_expanded(index))
        elif indicator == 'expand':
            assert_true(step, (not is_the_row_expanded(index)) and (not is_the_leaf_node(index)))
        else:
            assert_true(step, is_the_leaf_node(index))


@step('Stop mountebank$')
def stop_mb(step):
    with AssertContextManager(step):
        bo.stop_mb()


@step('Start mountebank$')
def start_mb(step):
    with AssertContextManager(step):
        bo.start_mb()


@step('The default loading indicator should display on (\d+) items$')
def check_default_loading_indicator(step, num, timeout=5):
    with AssertContextManager(step):
        try:
            start = time.time()
            while time.time() - start < timeout:
                indicator = world.browser.execute_script("return $('.row-loading-indicator.loading')")
                if len(indicator) == int(num):
                    return
                time.sleep(0.2)
            raise AssertionError
        finally:
            if int(num) != 0:
                bo.start_mb()


@step('The custom loading indicator should display on (\d+) items$')
def check_custom_loading_indicator(step, num):
    with AssertContextManager(step):
        indicator = world.browser.execute_script("return $('.custom-row-loading-indicator.loading')")
        assert_equal(len(indicator), int(num))


@step('The row "(.*?)" indicator should be "(.*?)" with customized$')
def check_row_indicator(step, row_name, indicator):
    with AssertContextManager(step):
        row = world.browser.execute_script(
            "return $('.ember-table-content:contains(" + str(row_name) + ")').siblings()")
        if indicator == "expand":
            assert_true(step, ("unfold" not in row[1].get_attribute("class")) and is_the_row_custom(row_name))
        else:
            assert_true(step, ("unfold" in row[1].get_attribute("class")) and is_the_row_custom(row_name))


def is_the_row_custom(row_name):
    return world.browser.execute_script(
        "return $('.ember-table-content:contains(" + row_name + ")').siblings().hasClass('custom-grouped-row-indicator')")


@step('There are (\d+) grouped loans$')
def prepare_grouping_loans(step, count):
    with AssertContextManager(step):
        prepare_grouping_data(count)


@step('The "(.*?)" should not be scrolled$')
def check_grouping_column_should_not_scroll(step, column_name):
    with AssertContextManager(step):
        columns = world.browser.execute_script(
            "return $('.ember-table-header-container .ember-table-content').parent().parent()")
        for index, col in enumerate(columns):
            name = world.browser.execute_script(
                "return $('.ember-table-header-container .ember-table-content:eq(" + str(index) + ")').text().trim()")
            if column_name in name:
                num = index
        grouping_column_scroll_left = world.browser.execute_script(
            "return $('.lazy-list-container:eq(" + str(num) + ")').scrollLeft()")

        assert_true(step, int(grouping_column_scroll_left) == 0)


@step('The grouping and fixed columns should not be scrolled$')
def check_grouping_fixed_should_not_scroll(step):
    with AssertContextManager(step):
        grouping_fixed_scroll_left = world.browser.execute_script(
            "return $('.lazy-list-container:eq(0)').scrollLeft()")
        assert_true(step, int(grouping_fixed_scroll_left) == 0)


@step('There are (\d+) grouping and fixed columns$')
def check_grouping_fixed_num(step, num):
    with AssertContextManager(step):
        grouping_fixed_col_num = world.browser.execute_script(
            "return $('.ember-table-left-table-block:eq(0) .ember-table-header-cell').length")
        assert_equal(int(num), int(grouping_fixed_col_num))


@step('The column "(.*?)" should be fixed$')
def check_column_is_fixed(step, col_name):
    with AssertContextManager(step):
        col_names = world.browser.execute_script(
            "return $('.ember-table-table-fixed-wrapper > div:eq(0) span').text()")
        if str(col_name) == "GroupingColumn":
            assert_true(step, str("") in str(col_names))
        else:
            assert_true(step, str(col_name) in str(col_names))


@step('Prepare the grid with no existing sorting column for "(.*?)":')
def prepare_no_sort_col(step, fully_or_partial):
    with AssertContextManager(step):
        if "fully" in fully_or_partial:
            prepare_grouped_loans(step.hashes)
            step.given('Presenting "grouping column"')
        elif "lazily" in fully_or_partial:
            prepare_lazy_loaded_grouped_loans(step.hashes)
            step.given('Presenting "grouping column present partial loaded children"')
        elif "grouper" in fully_or_partial:
            prepare_lazy_loaded_grouped_loans(step.hashes)
            step.given('Presenting "grouper sort"')


@step('The grid sorted as "(.*?)" by "(.*?)" column:')
def prepare_asc_sort_col(step, asc_or_desc, col_name):
    with AssertContextManager(step):
        if not asc_or_desc == "none":
            times = 1 if asc_or_desc == "ASC" else 2
            bo.wait_loading_indicator_disappear(world.browser)
            for i in range(0, times):
                step.behave_as("""
                Given Click to sort as "{sort}" for column "{name}"
                """.format(sort=asc_or_desc, name=col_name))
        for index in range(0, len(step.hashes)):
            bo.wait_loading_indicator_disappear(world.browser)
            verify_grouped_row(index, step.hashes[index])
        step.behave_as("""
            Then The "{name}" column sort indicator should be "{sort}"
        """.format(name=col_name, sort=str(asc_or_desc).lower()))


@step('The grid sorted as "(.*?)" by "(.*?)" columns')
def prepare_asc_sort_col(step, asc_or_desc, cols_name):
    with AssertContextManager(step):
        time.sleep(2)
        columns = cols_name.split(",")
        for index in range(0, columns.__len__()):
            if not asc_or_desc == "none":
                times = 1 if asc_or_desc == "ASC" else 2
                bo.wait_loading_indicator_disappear(world.browser)
                for i in range(0, times):
                    step.behave_as("""
                    Given "command" click to sort as "{sort}" for column "{name}"
                    """.format(sort=asc_or_desc, name=columns[index].strip()))
            step.behave_as("""
                        Then The "{name}" column sort indicator should be "{sort}"
                    """.format(name=columns[index], sort=str(asc_or_desc).lower()))


@step('The grouped row "(.*?)" should not wrap')
def check_grouped_row_wrap(step, col_name):
    with AssertContextManager(step):
        indicator_offset = world.browser.execute_script(
            "return $('.grouping-column-cell .ember-table-content:contains(" + col_name + ")').siblings().eq(1).offset().left")
        name_offset = world.browser.execute_script(
            "return $('.grouping-column-cell .ember-table-content:contains(" + col_name + ")').offset().left")

        assert_true(step, int(indicator_offset) < int(name_offset))


@step('Click grouper "(.*?)" to sort as "(.*?)"$')
def click_grouper(step, name, direction):
    with AssertContextManager(step):
        element = world.browser.execute_script("return $('.sort-grouper:contains(" + name + ")')")
        while direction.lower() not in world.browser.execute_script(
                                "return $('.sort-grouper:contains(" + name + ")').text()"):
            element[0].click()
