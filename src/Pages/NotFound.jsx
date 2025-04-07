import { Link } from "react-router-dom";
import { ArrowLeft } from "lucide-react";

const NotFoundPage = () => {
	return (
		<div className="min-h-screen bg-[#030014] px-[2%] sm:px-0 relative overflow-hidden">
			<div className="fixed inset-0">
				<div className="absolute -inset-[10px] opacity-20">
					<div className="absolute top-0 -left-4 w-72 md:w-96 h-72 md:h-96 bg-purple-500 rounded-full mix-blend-multiply filter blur-3xl opacity-70 animate-blob" />
					<div className="absolute top-0 -right-4 w-72 md:w-96 h-72 md:h-96 bg-blue-500 rounded-full mix-blend-multiply filter blur-3xl opacity-70 animate-blob animation-delay-2000" />
					<div className="absolute -bottom-8 left-20 w-72 md:w-96 h-72 md:h-96 bg-pink-500 rounded-full mix-blend-multiply filter blur-3xl opacity-70 animate-blob animation-delay-4000" />
				</div>
				<div className="absolute inset-0 bg-[url('/grid.svg')] opacity-[0.02]" />
			</div>

			<div className="relative">
				<div className="max-w-7xl mx-auto px-4 md:px-6 py-8 md:py-16 space-y-6 text-center animate-slideInLeft">
					<h1 className="text-6xl md:text-8xl py-1 font-bold bg-gradient-to-r from-blue-200 via-purple-200 to-pink-200 bg-clip-text text-transparent leading-tight">
						404
					</h1>
					<p className="text-base md:text-lg text-gray-300/90 leading-relaxed">
						The page you are looking for does not exist.
					</p>
					<div className="flex items-center space-x-2 md:space-x-4 mb-8 md:mb-12 animate-fadeIn">
						<Link
							to="/"
							className="mx-auto group inline-flex items-center space-x-1.5 md:space-x-2 px-3 md:px-5 py-2 md:py-2.5 bg-white/5 backdrop-blur-xl rounded-xl text-white/90 hover:bg-white/10 transition-all duration-300 border border-white/10 hover:border-white/20 text-sm md:text-base"
						>
							<ArrowLeft className="w-4 h-4 md:w-5 md:h-5 group-hover:-translate-x-1 transition-transform" />
							<span>Back to Home</span>
						</Link>
					</div>
				</div>
			</div>

			<style>{`
                @keyframes blob {
                    0% {
                        transform: translate(0px, 0px) scale(1);
                    }
                    33% {
                        transform: translate(30px, -50px) scale(1.1);
                    }
                    66% {
                        transform: translate(-20px, 20px) scale(0.9);
                    }
                    100% {
                        transform: translate(0px, 0px) scale(1);
                    }
                }
                .animate-blob {
                    animation: blob 10s infinite;
                }
                .animation-delay-2000 {
                    animation-delay: 2s;
                }
                .animation-delay-4000 {
                    animation-delay: 4s;
                }
                .animate-fadeIn {
                    animation: fadeIn 0.7s ease-out;
                }
                .animate-slideInLeft {
                    animation: slideInLeft 0.7s ease-out;
                }
                .animate-slideInRight {
                    animation: slideInRight 0.7s ease-out;
                }
                @keyframes fadeIn {
                    from {
                        opacity: 0;
                    }
                    to {
                        opacity: 1;
                    }
                }
                @keyframes slideInLeft {
                    from {
                        opacity: 0;
                        transform: translateX(-30px);
                    }
                    to {
                        opacity: 1;
                        transform: translateX(0);
                    }
                }
                @keyframes slideInRight {
                    from {
                        opacity: 0;
                        transform: translateX(30px);
                    }
                    to {
                        opacity: 1;
                        transform: translateX(0);
                    }
                }
            `}</style>
		</div>
	);
};

export default NotFoundPage;
