# n=5 model=out iset=I1 prefix14_class=3819
mov S2, P3
cmp S2, P2
cmovg S2, P2
cmovge P2, P3
mov S0, P0
cmp P1, P0
cmovge P0, P1
cmovle S0, P1
mov P1, S2
cmp S2, S0
cmovl P1, S0
cmovle S0, S2
cmp P2, P0
cmovle S0, P0
