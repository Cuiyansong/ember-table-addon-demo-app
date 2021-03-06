import Ember from 'ember';
import ColumnDefinition from 'ember-table/models/column-definition';
import ColumnGroupDefinition from 'ember-table/models/column-group-definition';
import tablesMixin from '../mixins/features';

export default Ember.Controller.extend(tablesMixin, {

  title: 'Group Reorder',

  columns: function () {
    var idColumn, activityColumn, statusColumn,
      nameColumn, useColumn, sectorColumn;

    idColumn = ColumnDefinition.create({
      width: 60,
      textAlign: 'text-align-left',
      headerCellName: 'Id',
      getCellContent: function (row) {
        return row.get('id');
      }
    });

    activityColumn = ColumnDefinition.create({
      columnWidth: 150,
      textAlign: 'text-align-left',
      headerCellName: 'Activity',
      getCellContent: function (row) {
        return row.get('activity');
      }
    });

    statusColumn = ColumnDefinition.create({
      columnWidth: 100,
      headerCellName: 'Status',
      getCellContent: function (row) {
        return row.get('status');
      }
    });

    nameColumn = ColumnDefinition.create({
      columnWidth: 100,
      headerCellName: 'Name',
      getCellContent: function (row) {
        return row.get('name');
      }
    });

    useColumn = ColumnDefinition.create({
      columnWidth: 100,
      headerCellName: 'Use',
      getCellContent: function (row) {
        return row.get('use');
      }
    });

    sectorColumn = ColumnDefinition.create({
      columnWidth: 260,
      headerCellName: 'Sector',
      getCellContent: function (row) {
        return row.get('sector');
      }
    });

    var Group1 = ColumnGroupDefinition.create({
      cellStyle: "text-red",
      innerColumnStyle: "text-blue",
      firstColumnStyle: "bg-gray",
      lastColumnStyle: "bg-lightgray",
      groupStyle: "text-center",
      headerCellName: 'Group1',
      innerColumns: [idColumn, activityColumn, statusColumn]
    });

    var Group2 = ColumnGroupDefinition.create({
      cellStyle: "text-red",
      innerColumnStyle: "text-blue",
      firstColumnStyle: "bg-gray",
      lastColumnStyle: "bg-lightgray",
      groupStyle: "text-center",
      headerCellName: 'Person',
      innerColumns: [nameColumn, useColumn]
    });

    return [Group1, sectorColumn, Group2];

  }.property(),


  actions: {
    test: function () {
      this.get('content').clear();
    }
  }
});
