# n=5 model=out iset=I1 prefix14_class=12957
cmp P1, P0
mov S0, P0
cmovle P0, P1
cmovg S0, P1
mov S2, P0
cmp P2, P3
cmovg P1, P3
cmovge P3, P2
cmovg P2, P1
cmp P0, P2
cmovg S2, P2
cmovl P0, P2
cmp S0, P3
cmovle S2, S0
