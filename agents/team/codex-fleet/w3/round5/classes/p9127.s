# n=5 model=out iset=I1 prefix14_class=9127
mov S1, P2
cmp P2, P1
cmovl P2, P1
cmovge S1, P1
cmp P3, P0
cmovge P1, P3
cmovge P3, P0
mov S2, P2
mov S0, S1
cmovg P0, P1
cmp P3, S1
cmovle S1, P3
cmovg S0, P3
cmp P0, P2
