# n=5 model=out iset=I1 prefix14_class=9562
mov S2, P2
cmp S2, P1
cmovle P2, P1
mov S0, P0
cmovl P1, S2
cmp S0, P3
cmovle S0, P3
cmovge P0, P3
cmp P2, S0
mov P3, S0
cmovle S0, P2
cmovg P3, P2
cmp P0, P1
cmovg S2, P0
