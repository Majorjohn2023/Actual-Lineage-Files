import requests

def get_top_stories():
    """
    Fetches the top stories from the Hacker News API.
    
    Returns:
        list: A list of story IDs.
    """
    url = "https://hacker-news.firebaseio.com/v0/topstories.json"
    response = requests.get(url)
    
    if response.status_code == 200:
        return response.json()
    else:
        return []

# Example usage
top_stories = get_top_stories()
print(f"The current top {len(top_stories)} stories on Hacker News are:")
for story_id in top_stories:
    print(story_id)