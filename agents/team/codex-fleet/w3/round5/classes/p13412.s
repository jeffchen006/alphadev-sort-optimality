# n=5 model=out iset=I1 prefix14_class=13412
cmp P2, P0
cmovge S0, P2
cmovg P2, P0
mov S2, P1
cmovge P0, S0
cmp P3, S2
cmovg S2, P3
cmovl P1, P3
cmp P1, P2
mov S1, P2
cmovle S1, P1
cmovl P1, P2
cmp P0, S2
cmovg S0, S2
