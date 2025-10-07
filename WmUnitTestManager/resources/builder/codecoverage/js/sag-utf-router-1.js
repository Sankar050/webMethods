/* Copyright Super iPaaS Integration LLC, an IBM Company 2024
*/

(function () {
    var app = angular.module('app');

    app.config(function ($routeProvider) {
        $routeProvider
            .when("/view/mockdetails", {
                templateUrl: "partialView/baseRouterPage.html",
                controller: "treeTable-datarouter-mock"
            })
            .when("/view/executionmodel", {
                templateUrl: "partialView/baseRouterPage.html",
                controller: "treeTable-datarouter-em"
            })
            .when("/view/:param", {
                templateUrl: "partialView/baseRouterPage.html",
                controller: "treeTable-datarouter"
            })
            .otherwise({
                redirectTo: '/view/fullpackageview',
                controller: "treeTable-datarouter"
                //controller: "MainCtrl"
            });
    });

})();//.call(this);