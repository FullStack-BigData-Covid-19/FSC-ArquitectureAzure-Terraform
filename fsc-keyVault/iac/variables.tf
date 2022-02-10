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
