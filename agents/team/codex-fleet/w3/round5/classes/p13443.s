# n=5 model=out iset=I1 prefix14_class=13443
cmp P2, P1
cmovg S2, P2
cmovge P2, P1
cmovg P1, S2
cmp P0, P3
cmovle S2, P3
cmovle P3, P0
cmovg S2, P0
cmp P3, P2
cmovle S0, P2
cmovle P2, P3
cmovle P3, S0
cmp P1, S2
cmovl P0, P1
