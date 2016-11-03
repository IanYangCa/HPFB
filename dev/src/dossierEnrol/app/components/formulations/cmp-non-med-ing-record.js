/**
 * Created by Abdessamad on 9/25/2016.
 */

(function () {
    'use strict';

    angular
        .module('nonMedIngRecordModule', ['dossierDataLists'])
})();

(function () {
    'use strict';

    angular
        .module('nonMedIngRecordModule')
        .component('cmpNonMedIngRecord', {
            templateUrl: './components/formulations/tpl-non-med-ing-record.html',
            controllerAs: 'nIngRecCtrl',
            controller: nonMedIngRecCtrl,
            bindings: {
                deleteBtn: '<',
                record: '<',
                showErrors: '&',
                onAddIng: '&',
                onUpdate: '&',
                onDelete: '&',
                onCancel: '&'
            }

        });
    nonMedIngRecCtrl.$inject = ['DossierLists'];
    function nonMedIngRecCtrl(DossierLists) {

        var self = this;
        self.nanoMaterialList = DossierLists.getNanoMaterials(); //nanoMaterial list
        self.yesNoList = DossierLists.getYesNoList(); //yes-no lists
        self.$onInit = function () {

            self.ingModel = {};

            if (self.record) {
                self.ingModel = angular.copy(self.record);
            }
            self.backup = angular.copy(self.ingModel);
        };


        self.duplicate = function () {
            if (self.record) {
                self.onAddIng({ing: self.record});
            }
        };

        self.saveIng = function () {
            // self.ingModel.animalHumanSourced = self.ingModel.animalHumanSourced == true ? "Yes" : "No";
            if (self.record) {
                // console.log('product details update product');
                self.onUpdate({ing: self.ingModel});
            } else {
                //  console.log('product details add product');
                self.onAddIng({ing: self.ingModel});
            }

        };

        self.discardChanges = function () {
            self.ingModel = angular.copy(self.backup);
            self.nonMedIngForm.$setPristine();
            self.onCancel();
        };

        self.delete = function () {
            if (self.record) {
                //  console.log('product details delete product');
                self.onDelete();
            } else {

            }
        };

        self.$onChanges = function (changes) {
            if (changes.record) {
                self.ingModel = changes.record.currentValue;
            }
        };


        /**
         * Controls showing errors for a field
         * @param isInvalid
         * @param isTouched
         * @returns {*}
         */
        self.showError = function (isInvalid, isTouched) {
            return ((isInvalid && isTouched) || (isInvalid && self.showErrors()))
        };

        /**
         * Sets the state of the nanomaterial other field
         * @returns {boolean} true if other is the value
         */
        self.isNanoOther = function () {
            if (self.ingModel.nanoMaterial === DossierLists.getOtherValue()) {
                return true;
            } else {
                self.ingModel.nanoMaterialOther = "";
                return false;
            }
        };

    }

})();
