require 'test_helper'

class Queries::ModelsQueryTest < ActiveSupport::TestCase
  test 'fetching models attributes' do
    FactoryBot.create_list(:model, 2)

    query = <<-GRAPHQL
      query {
        models {
          totalCount
          pageInfo {
            startCursor
            endCursor
            hasNextPage
            hasPreviousPage
          }
          edges {
            cursor
            node {
              id
            }
          }
        }
      }
    GRAPHQL

    context = { current_user: FactoryBot.create(:user, :admin) }
    result = ForemanGraphqlSchema.execute(query, variables: {}, context: context)

    expected_count = Model.count

    assert_empty result['errors']
    assert_equal expected_count, result['data']['models']['totalCount']
    assert_equal expected_count, result['data']['models']['edges'].count
  end
end
