const TechStackIcon = ({ TechStackIcon, Language }) => {
	return (
		<div className="group p-4 rounded-2xl bg-slate-800/50 hover:bg-slate-700/50 transition-all duration-300 ease-in-out flex flex-col items-center justify-center gap-3 hover:scale-105 cursor-pointer shadow-lg hover:shadow-xl h-full">
			<div className="relative">
				<div className="absolute -inset-1 bg-gradient-to-r from-blue-500 to-purple-500 rounded-full opacity-0 group-hover:opacity-50 blur transition duration-300"></div>
				<img
					src={TechStackIcon}
					alt={`${Language} icon`}
					className="relative h-12 w-12 md:h-14 md:w-14 transform transition-transform duration-300"
				/>
			</div>
			<span className="text-slate-300 font-semibold text-sm md:text-md tracking-wide group-hover:text-white transition-colors duration-300">
				{Language}
			</span>
		</div>
	);
};

export default TechStackIcon;
