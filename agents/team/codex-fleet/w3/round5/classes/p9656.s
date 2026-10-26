# n=5 model=out iset=I1 prefix14_class=9656
cmp P0, P2
mov S1, P1
mov S0, P0
cmovle P0, P2
cmovge S0, P2
cmp S1, P3
cmovg P1, P3
cmovle S1, P3
cmp P0, S1
cmovge P2, P0
cmovge P0, S1
cmovge S1, P2
cmp S0, P1
cmovl P2, S0
