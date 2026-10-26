# n=5 model=out iset=I1 prefix14_class=5753
cmp P0, P1
cmovg S0, P0
cmovle S0, P1
mov S2, P3
cmovge P0, P1
mov S1, P0
cmp S2, P2
cmovg S2, P2
cmovg P2, P3
cmp S2, S1
cmovl P0, S2
cmovle S2, S1
cmp P2, S0
mov P0, S2
