<cfscript>			
			transaction {
				app = createapp();
				balancer = createbalancer();
				app.setbalancer(balancer);
				balancer.setapp(app);
				expect(app.getbalancer()).toBe(balancer);
				expect(balancer.getapp()).toBe(app);			
				transaction action='rollback';
			}
			</cfscript>