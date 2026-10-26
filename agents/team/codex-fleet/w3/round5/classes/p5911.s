# n=5 model=out iset=I1 prefix14_class=5911
cmp P3, P2
mov S0, P1
mov S2, P3
cmovle S2, P2
cmovge P3, P2
cmp P0, S0
cmovg S0, P0
cmovge P0, P1
cmp S2, S0
cmovl P1, S2
cmovle S2, S0
mov S2, P0
cmovl S0, P1
cmp S2, P3
