import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    static targets = ["addPayerTemplate", "addPayer", "addDebtorTemplate", "addDebtor"]
    connect() {
        console.log("Expense form controller is active")
        this.addPayerTemplate = this.addPayerTemplateTarget;
        this.addPayerContainer = this.addPayerTarget;
        this.addDebtorTemplate = this.addDebtorTemplateTarget;
        this.addDebtorContainer = this.addDebtorTarget;
        this.addPayer();
        this.addDebtor();
    }

    addPayer() {
        console.log("Add new payer");
        const newNode = this.addPayerTemplate.content.cloneNode(true)
        this.replaceNewIndex(newNode);
        this.addPayerContainer.appendChild(newNode);
    }

    addDebtor() {
        console.log("Add new debtor")
        const newNode = this.addDebtorTemplate.content.cloneNode(true);
        this.replaceNewIndex(newNode);
        this.addDebtorContainer.appendChild(newNode);
    }

    replaceNewIndex(obj) {
        const timestamp = new Date().getTime();

        obj.querySelectorAll("input").forEach((field) => {
            field.id = new Date().getTime();
            field.name = field.name.replace("new-index", timestamp)
        })
    }
}
