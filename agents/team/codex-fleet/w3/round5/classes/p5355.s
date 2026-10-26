# n=5 model=out iset=I1 prefix14_class=5355
cmp P2, P1
mov S1, P0
cmovg S0, P1
cmovg P1, P2
cmovle S0, P2
cmp P3, S1
cmovle S1, P3
cmovge P0, P3
mov S2, P1
cmp S1, S0
cmovle P3, S1
cmovl S1, S0
cmovle S0, P3
cmp P0, P1
