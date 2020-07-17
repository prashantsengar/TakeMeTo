# TakeMeTo

Websites like StumbleUpon and Digg worked well in the beginning but now they are just another website advertisement and spamming agencies (StumbleUpon is dead though). We thought of building a website discovery engine which rewards users who submit good quality websites with our own TM2 tokens. 

## How is TakeMeTo better than its competitors:

1. **Quality checking** - Each URL submitted by a user first goes through a vetting process before actually being introduced in the system. The vetting process is done by the members of the community. This ensures that no one person is able to spam the system. 

2. **Rewards** - The problem with mainstream social media is that they use people to curate content from them and then do not reward their users with anything. TakeMeTo rewards users who post quality links by rewarding them with TM2 tokens. Community members who participate in the staking process also receive rewards for their contribution.

3. **Reputation** - Users who contribute well to the service are rewarded with reputation points and their voting value becomes higher.

All of our points make sure that the quality of the content that we have on the system is top-notch and spam-free.

Contract address: https://testnetv3-explorer.matic.network/tokens/0x14193B573fc6d6f98cb61b2112954213Db1d5FEe

API: [Non-functional currently]

Demo: https://youtu.be/5YIu_i5U2o8

### API endpoints (Public)

- **submit**: Submit a URL
    /submit?url=&title=&submitter=&category=
    
    [REQUIRED]
    
    category [int]
    
    url [str]
    
    title [str]
    
    submitter [ethereum wallet address as str]
    
    
- **takemeto**: Return a random website
    /takemeto?category=
    
    [OPTIONAL]
    
    category [int]

- **vote**: Stake on a submitted URL
    /vote
    
    [REQUIRED]
    
    ID [int]
    
    addr [str]
    
    vote [bool]
    
    tokens [int]

- **removestakes**: Remove stakes from a staked URL
    /removestakes
    
    [REQUIRED]
    
    ID [int]
    
    addr [str]
    
- **claimreward**: Claim your rewards after staking process
    /removestakes
    
    [REQUIRED]
    
    ID [int]
    
    addr [str]

- **isstaked**: Check if the given URL is under staking or not
    /removestakes
    
    [REQUIRED]
    
    ID [int]
    
