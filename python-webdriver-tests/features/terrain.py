from lettuce import before, after, world
from selenium import webdriver
import os

@before.all
def setup_browser():
    os.system('mb restart &')
    driver_arguments = {'chrome_options': webdriver.ChromeOptions()}
    driver_arguments['chrome_options'].add_argument('--no-sandbox')
    world.browser = webdriver.Chrome(chrome_options=driver_arguments['chrome_options'])


@after.all
def teardown_browser(total):
    world.browser.quit()
    os.system('mb stop')