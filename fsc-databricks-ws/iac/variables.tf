variable "tags" {
    type = map(string)
    default = {
        developer = "Arturo"
        env = "dev"
        project = "fullStack-BigData-Covid19"
    }
}
variable "location" {
    type = string
    default = "westeurope"
}

variable "rg_demos" {
    type = string
    default = "training_and_demos"
}