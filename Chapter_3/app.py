#!/usr/bin/env python3

from aws_cdk import core

from ecs_microservice.ecs_microservice_stack import EcsMicroserviceStack
from visits_microservice.visits_microservice_stack import VisitsMicroserviceStack


app = core.App()
monolith = EcsMicroserviceStack(app, "ecs-microservice-stack")
visits = VisitsMicroserviceStack(app, "visits-microservice-stack", monolith.rdsInst)

visits.add_dependency(monolith)

app.synth()
