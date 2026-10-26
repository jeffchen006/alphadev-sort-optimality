# n=5 model=out iset=I1 prefix14_class=11761
mov S2, P3
cmp P3, P0
cmovg S2, P0
cmovg P0, P3
cmp P2, P1
mov S1, P0
cmovle S0, P2
cmovl P2, P1
cmovl P1, S0
cmp P2, P0
cmovge P0, P2
cmovge P2, S1
cmp S2, P1
cmovge P0, S2
