# n=5 model=out iset=I1 prefix14_class=2981
cmp P2, P0
cmovle S0, P0
mov S2, P3
cmovl P0, P2
cmovg S0, P2
cmp S2, P1
cmovge P3, P1
cmovge P1, S2
mov S2, S0
cmp P1, S0
cmovle S2, P1
cmovg S0, P1
cmp P0, P3
mov S0, S2
