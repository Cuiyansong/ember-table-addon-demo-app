import Ember from 'ember';

export default Ember.Mixin.create({
  sortName: null,
  sortDirect: null,
  model: function () {
    var self = this;
    var groupingMetadata = this.get('groupingMetadata');
    return {
      loadChildren: function (chunkIndex, sortingColumns, groupQuery) {
        var parameters = {
          section: chunkIndex + 1,
          groupQuery: groupQuery
        };
        parameters.section = chunkIndex + 1;
        var grouperSortDirection = [];
        groupQuery.upperGroupings.forEach(function(item) {
          if (item[2]) {
            grouperSortDirection.push([item[0], item[2]]);
          }
        });
        var isSortByGrouper = groupQuery.key && groupQuery.sortDirection;
        if (isSortByGrouper) {
          grouperSortDirection.push([groupQuery.key, groupQuery.sortDirection]);
        }

        grouperSortDirection.forEach(function(item, idx) {
          parameters['sortNames[' + idx + ']'] = item[0];
          parameters['sortDirects[' + idx + ']'] = item[1];
        });

        if (!isSortByGrouper) {
          var sortQuery = self.makeSortQuery(sortingColumns);
          Ember.setProperties(parameters, sortQuery);
        }
        return self.store.find('chunked-group', parameters).then(function (result) {
          var meta = self.store.metadataFor('chunked-group');
          return {
            content: result,
            meta: {
              totalCount: meta.total,
              chunkSize: meta.pageSize
            }
          };
        });
      },
      groupingMetadata: groupingMetadata
    };
  },

  actions: {
    sortAction: function (sortingColumns) {
      this.set('sortingColumns', sortingColumns);
    }
  },

  isLastLevel: function (groupKey) {
    var groupingMetadata = this.get('groupingMetadata');
    var lastLevelQueryKey = groupingMetadata[groupingMetadata.length - 1].id;
    return groupKey === lastLevelQueryKey;
  },

  groupingMetadata: [{id: 'accountSection'}, {id: 'accountType'}, {id: 'accountCode'}]
});
