Configuration LocalServer {

        Node Local {

            File Test {
                DestinationPath = "D:\ADsc"
                Ensure = "Present"
                Type = "Directory"
            }

            File Test2 {
                DestinationPath = "D:\ADsc2"
                Ensure = "Present"
                Type = "Directory"
            }
        }
}