/**
 * Created by dkilty on 9/18/2016.
 */
/**
 * Created by dkilty on 6/4/2016.
 */


(function () {
    'use strict';

    angular
        .module('dossierDataLists', []);

})();

/**
 * getCountryAndProvinces services
 * Returns Canada or US condes, canada provinces, us states
 */
(function () {
    'use strict';

    angular
        .module('dossierDataLists')
        .factory('DossierLists', getService);

    /* @ngInject */
    function getService() {
        var OTHER = "OTHER";
        var service = {
            getDosageFormList: getDosageFormsArray,
            getDosageOther: getDoseOtherValue,
            getNanoMaterials: getNanoMaterialArray,
            getRoa: getRoaArray,
            getOtherValue: getOtherValue, //TODO make a constant instead
            getUnknownValue: getUnknownValue, //TODO make a constant instead
            getYesNoList: yesNoArray,
            getYesNoUnknownList: yesNoUnknownArray,
            getAnimalSources: animalSourcesArray,
            getTissuesSystem:tissuesSystemArray,
            getNervousSystem:nervousSystemArray(),
            getDigestiveSystem:digestiveSystemArray(),
            getImmuneSystem:immuneSystemArray(),
            getSkinSystem:skinSystemArray(),
            getReprodSystem:reprodSystemArray(),
            getOtherSystem:otherSystemArray(),
            getMuscleSystem:muscleSystemArray(),
            getCardioSystem:cardioSystemArray()
        };
        return service;


        ////////////////
        function getDoseOtherValue() {
            return OTHER;
        }

        function getUnknownValue() {
            return "UNLKNOWN";
        }

        function getOtherValue() {
            return getDoseOtherValue();
        }

        function getDosageFormsArray() {
            return ([
                "AEROSOL",
                "BOLUS",
                "CAPSULE",
                "CAPSULE_DELAYED_RELEASE",
                "CAPSULE_EXTENDED_RELEASE",
                "CREAM",
                "EMULSION",
                "GAS",
                "GEL",
                "IMPLANT",
                "LOTION",
                "LOZENGE",
                "OINTMENT",
                "PATCH",
                "PATCH_EXTENDED_RELEASE",
                "POWDER",
                "POWDER_FOR_SOLUTION",
                "POWDER_FOR_SUSPENSION",
                "SHAMPOO",
                "SOLUTION",
                "SPRAY",
                "SPRAY_BAG_ON_VALVE",
                "SPRAY_METERED_DOSE",
                "STICK",
                "STRIP",
                "SUPPOSITORY",
                "SUSPENSION",
                "SYRUP",
                "TABLET",
                "TABLET_CHEWABLE",
                "TABLET_DELAYED_RELEASE",
                "TABLET_EXTENDED_RELEASE",
                "TABLET_ORALLY_DISINTEGRATING",
                "WIPE",
                OTHER
            ]);

        }

        function getNanoMaterialArray() {
            return ([
                "NOTNANO",
                "NANOPARTICLE",
                "DENDRIMER",
                "LIPOSOMES",
                "MICELLES",
                "NANOEMULSIONS",
                "NANOCRYSTAL",
                "METALCOLLOIDS",
                OTHER
            ]);
        }

        function getRoaArray() {

            return ([
                "BLOCK_INFILTRATION",
                "BUCCAL",
                "DENTAL",
                "DIALYSIS",
                "EPIDURAL",
                "INHALATION",
                "INTRA-ARTERIAL",
                "INTRA-ARTICULAR",
                "INTRABURSAL",
                "INTRADERMAL",
                "INTRAMAMMARY",
                "INTRAOCULAR",
                "INTRAPERITONEAL",
                "INTRATHECAL",
                "INTRATRACHEAL",
                "INTRAVASCULAR",
                "INTRAVENOUS",
                "INTRAVITREAL",
                "IRRIGATION",
                "NASAL",
                "OPHTHALMIC",
                "ORAL",
                "OTIC",
                "RECTAL",
                "SUBCUTANEOUS",
                "SUBLINGUAL",
                "TOPICAL",
                "TRANSDERMAL",
                "URETHRAL",
                "VAGINAL",
                OTHER
            ]);
        }

        function yesNoArray() {

            return ([
                "Y",
                "N"
            ]);
        }

        function yesNoUnknownArray() {

            return ([
                "Y",
                "N",
                "UNKNOWN"
            ]);
        }


        function animalSourcesArray() {

            return ([
                "NONHUMANPRIMATE_TYPE",
                "AQUATIC_TYPE",
                "AVIAN_TYPE",
                "BOVINE_TYPE",
                "CANINE_TYPE",
                "CAPRINE_TYPE",
                "CERVIDAE_TYPE",
                "EQUINE_TYPE",
                "FELINE_TYPE",
                "OVINE_TYPE",
                "PORCINE_TYPE",
                "RODENT_TYPE",
                "OTHERANIMAL_TYPE"
            ]);
        }

        /**
         * Tisssues and fluids system types
         * @returns {string[]}
         */
        function tissuesSystemArray() {

            return ([
                "DIGESTIVE_SYSTEM",
                "NERVOUS_SYSTEM",
                "REPRODUCT_SYSTEM",
                "CARDIO_SYSTEM",
                "IMMUNE_SYSTEM",
                "SKINGLAND_SYSTEM",
                "MUSCULO_SYSTEM",
                "OTHERTISSUE_SYSTEM"
            ]);
        }

        /**
         * Nervous system Tissues or fluids LOV
         * @returns {*[]}
         */
        function nervousSystemArray() {

            return ([
                "BRAIN",
                "BRAINSTEM",
                "CEREBELLUM",
                "CEROFLUID",
                "CEROFLUID",
                "DORSALROOT",
                "DURAMATER",
                "HYPOTHALAMUS",
                "RETINA",
                "SPINALCORD",
                "TRIGEMINAL",
                OTHER
            ]);
        }

        /**
         * Digestive system Tissues or fluids LOV
         * @returns {*[]}
         */
        function digestiveSystemArray() {

            return ([
                "APPENDIX",
                "BILE",
                "DISTALILEUM",
                "LARGEINTEST",
                "SALIVA",
                "SMALLINTESTINE",
                "STOMACH",
                OTHER
            ]);
        }
        /**
         * Reproductive system Tissues or fluids LOV
         * @returns {*[]}
         */
        function reprodSystemArray() {

            return ([
                "MILK",
                "KIDNEY",
                "COLOSTRUM",
                "MAMMARY",
                "OVARIES",
                "PLACENTA",
                "PLACENTAFLUID",
                "SEMEN",
                "TESTES",
                "URINE",
                OTHER
            ]);
        }
        /**
         * Cardio system Tissues or fluids LOV
         * @returns {*[]}
         */
        function cardioSystemArray() {
            return ([
                "HEART",
                "LUNG",
                "NASALFLUID",
                "TRACHEA",
                "PLACENTALFLUID",
                "CARDIOOTHER",
                OTHER
            ]);
        }
        /**
         * Immune system Tissues or fluids LOV
         * @returns {*[]}
         */
        function immuneSystemArray() {
            return ([
                "LYMPH",
                "SPLEEN",
                "THYMUS",
                "TONSILS",
                OTHER
            ]);
        }

        /**
         * Skin system Tissues or fluids LOV
         * @returns {*[]}
         */
        function skinSystemArray() {
            return ([
                "ADRENAL",
                "HAIR",
                "LIVER",
                "PANCREAS",
                "PITUARYGLAND",
                "SKINHIDES",
                "THYROID",
                OTHER
            ]);
        }
        /**
         * Muscle system Tissues or fluids LOV
         * @returns {*[]}
         */
        function muscleSystemArray() {
            return ([
                "ABDOMEN",
                "SKULL",
                "BONES",
                "COLLAGEN",
                "TENDONS",
                "VERTEBRALCOLUMN",
                "MUSCLE",
                OTHER
            ]);
        }
        /**
         * Other system Tissues or fluids LOV
         * @returns {*[]}
         */
        function otherSystemArray() {
            return ([
                "ADIPOSE",
                "ASCITES",
                "ANTLERV",
                "SERUM",
                "WHOLEBLOOD",
                "PLASMA",
                "EMBRYONICTISS",
                "FETALTISS",
                "BONEMARROW",
                "EYESCORNEA",
                "GALL",
                OTHER
            ]);
        }


    }


})();
