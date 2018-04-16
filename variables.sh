#!/bin/bash

setEnvironmentVariables(){
export NODE_ENV=production
export configEnvVar=DATABASE_URL
export DATABASE_URL=postgres://postgres:daddy@10.0.1.4:5432/postgres?ssl=true
export configDialect=postgres
export ClientId=1020610939165-pgmi2vuh8broeahhfo1v6vfqueb92sak.apps.googleusercontent.com
export CloudName=chuks-andela32
export SECRET=secret123
export UploadPreset=jdhszyow
export HOST=https://www.chuks-zone.com.ng
export swaggerJSON=https://www.chuks-zone.com.ng/swagger.json
export swaggerTitle="Chuks Recipes"
export swaggerVersion=1.0.0
export swaggerDescription="An Online Recipe management platform API Documentation"
export swaggerName="Durugo Chukwukadibia"
export swaggerUrl=https://www.chuks-zone.com.ng
export swaggerEmail=chukwukadibia.durugo@andela.com
export swaggerHost=https://www.chuks-zone.com.ng
}

setEnvironmentVariables