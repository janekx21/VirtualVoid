export default class Issue {
    public id: string = "";
    public number: number = 0;
    public title: string = "";
    public description: string = "";

    constructor(id: string, number: number, title: string, description: string) {
        this.id = id;
        this.number = number;
        this.title = title;
        this.description = description;
    }
}
