# n=5 model=out iset=I1 prefix14_class=11755
mov S0, P2
cmp S0, P0
cmovge S0, P0
cmovge P0, P2
cmp P1, P3
cmovle S1, P1
cmovl P1, P3
cmovle P3, S1
mov P2, P0
cmp P1, P0
cmovg P0, P1
cmovge P1, P2
cmp S0, P3
mov P0, S0
