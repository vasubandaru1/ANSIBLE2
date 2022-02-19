help:
	@grep "####" Makefile | grep -v grep | sed -e "s/####//"

git-pull:
	@echo -e "\e[32m......PULLING CODE.......\e[0m"
	@git pull &>/dev/null


cart: git-pull #### setup cart component
	@sudo bash component/cart.sh

catalogue: git-pull #### setup catalogue component
	@sudo bash component/catalogue.sh

frontend: git-pull #### setup frontend component
	@sudo bash component/frontend.sh

mongodb: git-pull #### setup mongodb component
	@sudo bash component/mongodb.sh

mysql: git-pull #### setup mysql component
	@sudo bash component/mysql.sh

payment: git-pull #### setup payment component
	@sudo bash component/payment.sh

redis: git-pull #### setup redis component
	@sudo bash component/redis.sh

shipping: git-pull #### setup shipping component
	@sudo bash component/shipping.sh

user: git-pull #### setup user component
	@sudo bash component/user.sh

rabbitmq: git-pull #### setup rabbitmq component
	@sudo bash component/rabbitmq.sh