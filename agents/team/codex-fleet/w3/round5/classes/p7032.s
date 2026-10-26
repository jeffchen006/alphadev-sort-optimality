# n=5 model=out iset=I1 prefix14_class=7032
mov S2, P1
cmp P2, P1
cmovg P1, P2
cmovge P2, S2
mov S0, P3
mov S1, P2
cmp S0, P0
cmovg P3, P0
cmovl S0, P0
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
cmp S0, P1
cmovg P2, S0
