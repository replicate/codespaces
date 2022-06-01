.PHONY: push-install-cog
push-install-cog:
	gsutil cp scripts/install-cog.sh gs://replicate-public/codespaces/install-cog.sh
