# Upstream base image. Guardener should suggest the Chainguard python image for this reference.
FROM python:3.12

WORKDIR /app
COPY app/app.py .

EXPOSE 8080
# Exec form, so the image does not need a shell. This is what makes the swap clean.
CMD ["python", "app.py"]
