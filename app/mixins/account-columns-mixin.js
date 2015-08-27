import Ember from 'ember';
import ColumnDefinition from 'ember-table/models/column-definition';

export default Ember.Mixin.create({
  columns: function () {
    var columnTitleAndNames = [
      ["Id", "id", "decimal"],
      ["Beginning DR (Base)", "beginningDr", "decimal"],
      ["Beginning CR (Base)", "beginningCr", "decimal"],
      ["Net Beginning (Base)", "netBeginning", "decimal"],
      ["Activity DR (Base)", "activityDr", "decimal"],
      ["Activity CR (Base)", "activityCr", "decimal"],
      ["Net Activity (Base)", "netActivity", "decimal"],
      ["Ending DR (Base)", "endingDr", "decimal"],
      ["Ending CR (Base)", "endingCr", "decimal"],
      ["Net Ending (Base)", "netEnding", "decimal"]
    ];
    return columnTitleAndNames.map(function (column) {
      return ColumnDefinition.create({
        headerCellName: column[0],
        contentPath: column[1],
        dataType:column[2],
        getCellContent: function (row) {
          return Ember.get(row, column[1]);
        }
      });
    });
  }.property()
});
