# Upstream base image. Guardener should swap this for the Chainguard python image with the matching tag.
FROM cgr.dev/aj.com/python-fips:3.12

WORKDIR /app
COPY app/app.py .

EXPOSE 8080
# Exec-form ENTRYPOINT and no RUN or CMD. Guardener leaves a stage alone if it uses RUN, a shell-form
# CMD/ENTRYPOINT, or sets CMD without ENTRYPOINT, because Chainguard images set their own ENTRYPOINT.
# Keeping it this way is what makes the swap clean.
ENTRYPOINT ["python", "app.py"]
