# n=5 model=out iset=I1 prefix14_class=6605
cmp P3, P0
cmovle S0, P0
cmovle P0, P3
cmovge S0, P3
mov S1, P1
cmp S1, P2
cmovle P1, P2
cmovle P2, S1
cmp S0, P1
cmovl S1, S0
cmovge S1, P1
cmovg P1, S0
cmp P2, P0
mov P1, S1
