import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    static targets = ["addPayerTemplate", "addPayer", "addDebtorTemplate", "addDebtor"]
    connect() {
        console.log("Expense form controller is active")
        this.addPayerTemplate = this.addPayerTemplateTarget;
        this.addPayerContainer = this.addPayerTarget;
        this.addDebtorTemplate = this.addDebtorTemplateTarget;
        this.addDebtorContainer = this.addDebtorTarget;
        this.addPayerContainer.appendChild(this.addPayerTemplate.content.cloneNode(true));
        this.addDebtorContainer.appendChild(this.addDebtorTemplate.content.cloneNode(true));
    }

    addPayer() {
        console.log("Add new payer");
        this.addPayerContainer.appendChild(this.addPayerTemplate.content.cloneNode(true));
    }

    addDebtor() {
        console.log("Add new debtor")
        this.addDebtorContainer.appendChild(this.addDebtorTemplate.content.cloneNode(true));
    }
}
