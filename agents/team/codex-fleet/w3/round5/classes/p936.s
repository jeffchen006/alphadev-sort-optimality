# n=5 model=out iset=I1 prefix14_class=936
cmp P0, P2
mov S2, P2
cmovl P2, P0
cmovg S2, P0
cmp P3, P1
cmovge S1, P3
cmovge P3, P1
cmovge P1, S1
cmp P1, S2
mov S0, P1
cmovge P1, S2
cmovle S0, S2
mov S0, P2
cmp P3, P2
