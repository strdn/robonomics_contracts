const DutchAuction = artifacts.require('DutchAuction');
const KycAmbix = artifacts.require('KycAmbix');
const Factory = artifacts.require('Factory');
const XRT = artifacts.require('XRT');
const ENS = artifacts.require('ENS');

module.exports = async (deployer, network, accounts) => {

    config = require('../config');
    const ens_address = network === 'mainnet'
                      ? '0x314159265dD8dbb310642f98f50C066173C1259b'
                      : ENS.address; 
    const foundation = network === 'mainnet'
                     ? config['foundation']
                     : accounts[0];

    await deployer.deploy(XRT, config['xrt']['initialSupply']);
    await deployer.deploy(KycAmbix);
    await deployer.deploy(Factory,
                          DutchAuction.address,
                          ens_address,
                          XRT.address);

    const xrt = await XRT.deployed();
    await xrt.addMinter(Factory.address);
    await xrt.transfer(foundation, config['xrt']['genesis']['foundation']);
    await xrt.transfer(KycAmbix.address, config['xrt']['genesis']['ambix']);
    await xrt.transfer(DutchAuction.address, config['xrt']['genesis']['auction']);
    await xrt.renounceMinter();

    const auction = await DutchAuction.deployed();
    await auction.setup(XRT.address, KycAmbix.address);

};
