# n=5 model=out iset=I1 prefix14_class=3759
cmp P2, P1
cmovge S2, P1
cmovg P1, P2
mov S0, P0
cmovle S2, P2
mov P2, S2
cmp P3, S0
cmovg S0, P3
cmovge P3, P0
cmp P2, P3
cmovle P2, P3
cmovl P3, S2
cmp P1, S0
cmovge S2, S0
