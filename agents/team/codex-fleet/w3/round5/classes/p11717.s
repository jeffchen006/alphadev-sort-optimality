# n=5 model=out iset=I1 prefix14_class=11717
cmp P2, P1
mov S0, P3
mov S2, P2
cmovle S2, P1
cmovle P1, P2
cmp S0, P0
cmovg S0, P0
cmovl P3, P0
mov P2, P1
cmp P3, S2
cmovge S1, P3
cmovge P3, S2
cmovge S2, S1
cmp P1, S0
