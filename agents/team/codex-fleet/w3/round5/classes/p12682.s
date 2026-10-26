# n=5 model=out iset=I1 prefix14_class=12682
cmp P3, P1
mov S1, P0
cmovg S0, P1
cmovg P1, P3
cmovg P3, S0
cmp P2, S1
cmovle S1, P2
cmovle P2, P0
mov P0, P3
cmp S1, P0
cmovge P0, S1
cmovl P3, S1
cmp P1, P2
cmovge S0, P2
