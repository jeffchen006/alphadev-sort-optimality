# n=5 model=out iset=I1 prefix14_class=395
cmp P2, P3
cmovg S2, P2
mov S0, P0
cmovle S2, P3
cmovl P3, P2
cmp S0, P1
cmovg P0, P1
cmovg P1, S0
mov S1, P0
cmp S1, P3
cmovle S1, P3
cmovge P0, P3
cmp S2, P1
mov P0, P1
