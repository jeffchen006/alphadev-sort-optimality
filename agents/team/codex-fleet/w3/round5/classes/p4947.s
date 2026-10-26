# n=5 model=out iset=I1 prefix14_class=4947
mov S0, P1
cmp P3, P2
cmovle S2, P2
cmovg S2, P3
cmovg P3, P2
cmp P1, P0
cmovle S0, P0
cmovl P0, P1
cmp P3, P0
cmovge P2, P3
cmovge P3, P0
cmovge P0, P2
cmp S2, S0
mov S1, S0
