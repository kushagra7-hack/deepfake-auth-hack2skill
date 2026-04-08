'use client'

import { useRef } from "react"
import { motion, useScroll, useTransform } from 'framer-motion'
import { ArrowDown } from "lucide-react"

export const ParallaxScrollFeatureSection = () => {
    // Array of section data tailored for Deepfake Detection
    const sections = [
        {
            id: 1,
            title: "Biometric Facial Mapping",
            description: "Advanced AI analysis detects microscopic inconsistencies in facial muscle topography and lighting patterns, exposing visual deepfake manipulation with 99.9% accuracy.",
            imageUrl: 'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?q=80&w=800&auto=format&fit=crop',
            reverse: false
        },
        {
            id: 2,
            title: "Spectral Audio Forensics",
            description: "Our proprietary neural engine breaks down frequency patterns, identifying synthetic audio generation artifacts and voice cloning completely invisible to the human ear.",
            imageUrl: 'https://images.unsplash.com/photo-1550751827-4bd374c3f58b?q=80&w=800&auto=format&fit=crop',
            reverse: true
        },
        {
            id: 3,
            title: "Frame-Level Verification",
            description: "High-performance processing capability evaluates videos frame-by-frame, verifying the cryptographic integrity and temporal consistency of digital assets in real-time.",
            imageUrl: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?q=80&w=800&auto=format&fit=crop',
            reverse: false
        }
    ]

    // Create refs and animations for each section
    const sectionRefs = sections.map(() => useRef(null));
    
    const scrollYProgress = sections.map((_, index) => {
        return useScroll({
            target: sectionRefs[index],
            offset: ["start end", "center start"]
        }).scrollYProgress;
    });

    // Create animations for each section
    const opacityContents = scrollYProgress.map(progress => 
        useTransform(progress, [0, 0.7], [0, 1])
    );
    
    const clipProgresses = scrollYProgress.map(progress => 
        useTransform(progress, [0, 0.7], ["inset(0 100% 0 0)", "inset(0 0% 0 0)"])
    );
    
    const translateContents = scrollYProgress.map(progress => 
        useTransform(progress, [0, 1], [-50, 0])
    );

return (
  <div className="bg-transparent text-white font-['Outfit',sans-serif] relative z-10 w-full overflow-hidden">
  <div className='min-h-[70vh] w-full flex flex-col items-center justify-center relative pt-20 pb-10'>
        <h2 className='font-syne text-5xl md:text-6xl lg:text-7xl max-w-5xl text-center font-bold tracking-tight z-10 px-4'>
          CORE <span className="text-primary-500">CAPABILITIES</span>
        </h2>
        <p className='mt-8 text-neutral-400 text-lg md:text-xl text-center max-w-2xl px-4 z-10 font-light'>
          Our enterprise-grade infrastructure offers comprehensive protection against synthetic media attacks.
        </p>
        <p className='mt-20 flex items-center gap-2 text-sm uppercase tracking-widest text-neutral-500 z-10 animate-bounce'>
          Explore Features <ArrowDown size={16} />
        </p>
      </div>

       <div className="flex flex-col md:px-8 px-6 max-w-7xl mx-auto w-full pb-32">
            {sections.map((section, index) => (
                <div 
                    key={section.id}
                    ref={sectionRefs[index]} 
                    className={`min-h-[80vh] py-20 flex items-center justify-center gap-12 md:gap-24 flex-col md:flex-row ${section.reverse ? 'md:flex-row-reverse' : ''}`}
                >
                    <motion.div style={{ y: translateContents[index] }} className="flex-1 w-full relative z-10 flex flex-col justify-center">
                        <div className="flex items-center gap-4 mb-6">
                            <span className="text-primary-500/50 font-syne font-bold text-xl">0{section.id}</span>
                            <div className="h-px bg-white/10 flex-1"></div>
                        </div>
                        <h3 className="font-syne font-bold text-3xl md:text-4xl lg:text-5xl text-white mb-6 leading-tight">
                            {section.title}
                        </h3>
                        <motion.p 
                            style={{ y: translateContents[index] }} 
                            className="text-neutral-400 text-lg md:text-xl leading-relaxed"
                        >
                            {section.description}
                        </motion.p>
                    </motion.div>
                    
                    <motion.div 
                        style={{ 
                            opacity: opacityContents[index],
                            clipPath: clipProgresses[index],
                        }}
                        className="flex-1 w-full relative group"
                    >
                        <div className="absolute inset-0 bg-gradient-to-tr from-primary-500/20 to-purple-500/20 opacity-0 group-hover:opacity-100 transition-opacity duration-500 z-10 rounded-2xl pointer-events-none" />
<img
  src={section.imageUrl}
  className="w-full aspect-[4/3] md:aspect-[4/5] object-cover rounded-2xl shadow-2xl shadow-black border border-white/5 transition-all duration-700 hover:scale-[1.02]"
  alt={section.title}
/>
                    </motion.div>
                </div>
            ))}
        </div>
    </div>
  );
};
