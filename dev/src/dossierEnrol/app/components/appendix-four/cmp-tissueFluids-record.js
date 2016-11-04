/**
 * Created by dkilty on 04/11/2016.
 */

(function () {
    'use strict';

    angular
        .module('tissuesFluidsRecord', [])
})();

(function () {
    'use strict';

    angular
        .module('tissuesFluidsRecord')
        .component('cmpTissuesFluidsRecord', {
            templateUrl: './components/appendix-four/tpl-tiissueFluids-record.html',
            controller: tissuesFluidsController,
            controllerAs:'tissuesSrcCtrl',
            bindings: {
                record: '<',
                onDelete: '&',
                showErrors: '&'
            }
        });

    tissuesFluidsController.$inject=['DossierLists'];

    function tissuesFluidsController(DossierLists){
        var vm = this;
        vm.systemList = DossierLists.getTissuesSystem();
        vm.nervousList=DossierLists.getNervousSystem();
        vm.digestList=DossierLists.getDigestiveSystem();
        vm.cardioList=DossierLists.getCardioSystem();
        vm.otherList=DossierLists.getOtherSystem();
        vm.immuneList=DossierLists.getImmuneSystem();
        vm.skinList=DossierLists.getSkinSystem();
        vm.reprodList=DossierLists.getReprodSystem();
        vm.muscleList=DossierLists.getMuscleSystem();
        vm.selectedSystemList=[];
        vm.model = {};

        vm.$onInit = function(){

        };

        vm.$onChanges = function (changes) {

            if (changes.record) {
                vm.model=changes.record.currentValue;
                setSelectedList(vm.model.system)
            }
        };

        vm.deleteRecord = function()  {
            vm.onDelete({id: vm.model.id});
        };
        /**
         * Shows the errors for individual controls
         * @param ctrl
         * @returns {*}
         */
        vm.showError = function (ctrl) {
            if(!ctrl){
                console.warn("No control found in tissuesFluids-record")
                return false;
            }
            return ((ctrl.$invalid && ctrl.$touched) || (ctrl.$invalid && vm.showErrors()) )
        }
        vm.systemChanged=function(){
            setSelectedList(vm.model.system);
            //clear the values
            vm.model.systemDetails="";
            vm.model.otherDetails="";
        }

        /**
         * Sets the state of the other field when system details is other
         * @returns {boolean}
         */
        vm.isOther=function(){
            if( vm.model.systemDetails===DossierLists.getOtherValue()){
                return true;
            }else{
                vm.model.otherDetails="";
                return false;
            }
        }

        function setSelectedList(value){
            if(!value){
                vm.selectedSystemList=[];
            }
            switch(value){

                case 'NERVOUS_SYSTEM':
                    vm.selectedSystemList=vm.nervousList;
                    break;
                case 'DIGESTIVE_SYSTEM':
                    vm.selectedSystemList=vm.digestList;
                    break;
                case 'REPRODUCT_SYSTEM':
                    vm.selectedSystemList=vm.reprodList;
                    break;
                case 'CARDIO_SYSTEM':
                    vm.selectedSystemList=vm.cardioList;
                    break;
                case 'IMMUNE_SYSTEM':
                    vm.selectedSystemList=vm.immuneList;
                    break;
                case 'SKINGLAND_SYSTEM':
                    vm.selectedSystemList=vm.skinList;
                    break;
                case 'MUSCULO_SYSTEM':
                    vm.selectedSystemList=vm.muscleList;
                break;
                case 'OTHERTISSUE_SYSTEM':
                    vm.selectedSystemList=vm.otherList;
                    break;
                default:
                    console.warn("Invalid Tissues/Fluids System "+value);
                    vm.selectedSystemList=[];
                    break;
            }
        }


    }
})();