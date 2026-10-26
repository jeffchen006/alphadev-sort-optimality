# n=5 model=out iset=I1 prefix14_class=8052
mov S1, P1
mov S2, P2
cmp S1, P3
cmovge P1, P3
cmovl S1, P3
cmp P0, S2
cmovge P2, P0
mov S0, P1
cmovge P0, S2
cmp P1, P0
cmovl P1, P0
cmovg S0, P0
cmp S1, P2
cmovle S2, S1
