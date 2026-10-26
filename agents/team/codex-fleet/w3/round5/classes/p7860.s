# n=5 model=out iset=I1 prefix14_class=7860
mov S1, P3
cmp P2, S1
cmovge S1, P2
cmovle P3, P2
cmp P0, P1
cmovle P2, P0
cmovge P2, P1
cmovg P1, P0
cmp P2, P3
cmovle S0, P2
cmovl P2, P3
cmovl P3, S0
cmp S1, P1
cmovl S2, S1
