# n=5 model=out iset=I1 prefix14_class=10686
cmp P2, P0
cmovle S0, P0
mov S2, P1
cmovle P0, P2
cmovl P2, S0
cmp S2, P3
cmovge P1, P3
cmovle S2, P3
mov S1, P2
cmp S2, P2
cmovge S1, S2
mov P3, P1
cmovl P2, S2
cmovg S2, P2
