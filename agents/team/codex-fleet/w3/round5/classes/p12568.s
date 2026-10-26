# n=5 model=out iset=I1 prefix14_class=12568
mov S2, P3
cmp P0, S2
cmovge S2, P0
cmovge P0, P3
mov S0, P2
cmp P1, S0
cmovl S0, P1
cmovl P1, P2
cmp P0, S0
mov S1, P0
cmovle P0, S0
cmovg S1, S0
cmp P1, S2
cmovle S0, P0
