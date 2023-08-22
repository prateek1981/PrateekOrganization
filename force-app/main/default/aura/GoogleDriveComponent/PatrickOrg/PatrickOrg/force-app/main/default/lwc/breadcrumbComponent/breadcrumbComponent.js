import { LightningElement,api } from 'lwc';

export default class BreadcrumbComponent extends LightningElement {
    @api breadcrumbs;

    handleBreadcrumbs(event){
        console.log('HandleBreadCrumbs method is called');
    }
}