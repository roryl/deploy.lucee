<cfscript>			
			transaction {
				app = createapp();
				balancer = createbalancer();
				app.setbalancer(balancer);
				balancer.setapp(app);
				transaction action='commit';
			}
			expect(app.getbalancer()).toBe(balancer);
			expect(balancer.getapp()).toBe(app);			
			</cfscript>