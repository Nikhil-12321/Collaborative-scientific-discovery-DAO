module CollaborativeDAO::ScientificDiscovery {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a research project.
    struct ResearchProject has store, key {
        total_contributions: u64, // Total funds contributed to the project
        description: vector<u8>,  // Brief description of the project
    }

    /// Function to create a new research project.
    public fun create_project(owner: &signer, description: vector<u8>) {
        let project = ResearchProject {
            total_contributions: 0,
            description,
        };
        move_to(owner, project);
    }

    /// Function for contributors to fund a research project.
    public fun contribute_to_project(contributor: &signer, project_owner: address, amount: u64) acquires ResearchProject {
        let project = borrow_global_mut<ResearchProject>(project_owner);

        // Transfer funds from contributor to the project owner
        let contribution = coin::withdraw<AptosCoin>(contributor, amount);
        coin::deposit<AptosCoin>(project_owner, contribution);

        // Update the total contributions for the project
        project.total_contributions = project.total_contributions + amount;
    }
}
